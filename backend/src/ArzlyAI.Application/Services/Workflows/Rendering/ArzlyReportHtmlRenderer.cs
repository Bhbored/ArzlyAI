using System.Globalization;
using System.Net;
using System.Text;
using System.Text.Json;

namespace ArzlyAI.Application.Services.Workflows.Rendering;

public sealed class ArzlyReportHtmlRenderer : IWorkflowResultRenderer
{
    public bool CanRender(string contractKey, int contractVersion) =>
        contractKey.Equals("arzly.report", StringComparison.Ordinal) && contractVersion is >= 1 and <= 4;

    public string Render(JsonElement document)
    {
        var title = Text(document, "title", "Your purchase decision");
        var summary = Text(document, "summary", string.Empty);
        var generatedAt = Text(document, "generatedAtUtc", string.Empty);
        var blocks = Blocks(document);
        var recommendation = blocks.FirstOrDefault(block => Type(block) == "recommendation");
        var content = new StringBuilder();

        if (recommendation.ValueKind == JsonValueKind.Object)
            AppendRecommendation(content, recommendation, summary);

        var renderedTypes = new HashSet<string>(StringComparer.Ordinal) { "recommendation", "sourceList" };
        foreach (var block in blocks)
        {
            var type = Type(block);
            if (!renderedTypes.Add(type)) continue;
            switch (type)
            {
                case "candidateComparison":
                    AppendComparison(content, block);
                    break;
                case "scoreBreakdown":
                    AppendDisclosure(content, block, "See how the options were scored");
                    break;
                case "rejectedCandidates":
                    AppendDisclosure(content, block, "See options that did not make the cut");
                    break;
                case "riskCallout":
                    AppendCompactSection(content, block, "caution");
                    break;
                case "prosCons":
                case "nextSteps":
                    AppendCompactSection(content, block, string.Empty);
                    break;
                default:
                    AppendCompactSection(content, block, string.Empty);
                    break;
            }
        }

        var sources = RenderSources(document);
        var date = string.IsNullOrWhiteSpace(generatedAt)
            ? string.Empty
            : $"<div class=\"date\">Research snapshot · {Encode(generatedAt)}</div>";

        return $$$"""
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <meta http-equiv="Content-Security-Policy" content="default-src 'none'; img-src https: http: data: blob:; style-src 'unsafe-inline'; font-src data:; base-uri 'none'; form-action 'none'">
  <title>{{{Encode(title)}}}</title>
  <style>
    :root{color-scheme:light dark;--bg:#f6f6f4;--surface:#fff;--surface-2:#f0f0ec;--ink:#171717;--muted:#5d5d58;--line:#deded8;--accent:#a16207;--accent-soft:#fff7df;--danger:#a12b24;--danger-soft:#fff0ed;--on-accent:#fff}
    @media(prefers-color-scheme:dark){:root{--bg:#10110f;--surface:#191a17;--surface-2:#22231f;--ink:#f5f5ef;--muted:#b7b7af;--line:#373831;--accent:#e6ad42;--accent-soft:#32280f;--danger:#ff9b91;--danger-soft:#351d1b;--on-accent:#17120a}}
    *{box-sizing:border-box}html{scroll-behavior:smooth}body{margin:0;background:var(--bg);color:var(--ink);font:16px/1.6 system-ui,-apple-system,"Segoe UI",sans-serif;-webkit-font-smoothing:antialiased}a{touch-action:manipulation}.skip{position:absolute;left:-9999px}.skip:focus{left:16px;top:16px;z-index:2;background:var(--ink);color:var(--surface);padding:12px 16px;border-radius:10px}
    main{width:min(calc(100% - 32px),920px);margin:auto;padding:32px 0 56px}.masthead{padding:8px 0 28px;border-bottom:1px solid var(--line)}.eyebrow{color:var(--accent);font-size:.78rem;font-weight:800;letter-spacing:.12em;text-transform:uppercase}h1{max-width:780px;margin:8px 0 12px;font-size:clamp(2rem,8vw,4rem);line-height:1.05;letter-spacing:-.045em}.lead{max-width:720px;color:var(--muted);font-size:1.06rem}.date{margin-top:12px;color:var(--muted);font-size:.8rem}
    section{margin-top:32px}.section-head{margin-bottom:16px}.kicker{color:var(--accent);font-size:.75rem;font-weight:800;letter-spacing:.1em;text-transform:uppercase}h2{margin:2px 0 4px;font-size:1.35rem;line-height:1.25}h3{margin:0;font-size:1.08rem;line-height:1.3}.section-copy{margin:4px 0 0;color:var(--muted);max-width:680px}.panel{border:1px solid var(--line);border-radius:20px;background:var(--surface)}
    .winner{display:grid;overflow:hidden}.winner-media{aspect-ratio:16/10;background:var(--surface-2)}.winner-media img,.product-media img{display:block;width:100%;height:100%;object-fit:cover}.winner-body{padding:24px}.winner-price{margin:6px 0;color:var(--accent);font-size:1.45rem;font-weight:800;font-variant-numeric:tabular-nums}.description{margin:8px 0 0;color:var(--muted)}
    .products{display:grid;gap:12px}.product{display:grid;grid-template-columns:112px 1fr;overflow:hidden}.product.no-image{grid-template-columns:1fr}.product-media{min-height:140px;background:var(--surface-2)}.product-body{padding:18px}.product-price{margin-top:4px;color:var(--accent);font-weight:800;font-variant-numeric:tabular-nums}
    .offers{display:grid;gap:8px;margin-top:18px}.offer{display:flex;align-items:center;justify-content:space-between;gap:12px;padding-top:10px;border-top:1px solid var(--line)}.store{display:block;font-weight:750}.availability{display:block;color:var(--muted);font-size:.78rem}.action{display:inline-flex;min-height:48px;align-items:center;justify-content:center;padding:10px 16px;border:1px solid var(--line);border-radius:12px;color:var(--ink);background:var(--surface);text-decoration:none;font-weight:750;text-align:center;transition:background-color .18s ease,border-color .18s ease}.action.primary{border-color:var(--accent);background:var(--accent);color:var(--on-accent)}.action:hover{background:var(--surface-2)}.action.primary:hover{filter:brightness(.94)}.action:focus-visible,summary:focus-visible{outline:3px solid var(--accent);outline-offset:3px}
    .compact{padding:20px}.compact.caution{border-color:var(--danger);background:var(--danger-soft)}.items{display:grid;gap:10px;margin-top:14px}.plain-item{padding-top:10px;border-top:1px solid var(--line)}.item-value{color:var(--accent);font-weight:750}.item-detail{color:var(--muted);font-size:.92rem}.metrics{margin-top:14px}.metric{margin:12px 0}.metric-head{display:flex;justify-content:space-between;gap:12px;font-size:.9rem}.metric-head strong{font-variant-numeric:tabular-nums}.track{height:8px;margin-top:5px;background:var(--surface-2);border-radius:99px;overflow:hidden}.fill{height:100%;background:var(--accent);border-radius:inherit}
    details{margin-top:20px;border:1px solid var(--line);border-radius:16px;background:var(--surface)}summary{min-height:48px;padding:14px 18px;cursor:pointer;font-weight:750;list-style-position:inside}.detail-body{padding:0 18px 18px}.sources ol{margin:8px 0 0;padding-left:22px}.sources li{margin:10px 0;color:var(--muted)}.sources a{color:var(--ink);text-decoration-color:var(--accent);text-underline-offset:3px}
    @media(min-width:700px){main{padding-top:48px}.winner{grid-template-columns:minmax(260px,40%) 1fr}.winner-media{aspect-ratio:auto;min-height:360px}.products{grid-template-columns:1fr 1fr}.product{grid-template-columns:1fr}.product-media{aspect-ratio:16/10}.offer{align-items:flex-end}}
    @media(max-width:430px){main{width:min(calc(100% - 24px),920px)}.product{grid-template-columns:88px 1fr}.product-media{min-height:120px}.offer{align-items:stretch;flex-direction:column}.action{width:100%}}
    @media(prefers-reduced-motion:reduce){html{scroll-behavior:auto}.action{transition:none}}
  </style>
</head>
<body><a class="skip" href="#decision">Skip to decision</a><main>
  <header class="masthead"><div class="eyebrow">ArzlyAI · Smart Buy</div><h1>{{{Encode(title)}}}</h1><div class="lead">{{{Encode(summary)}}}</div>{{{date}}}</header>
  <div id="decision">{{{content}}}</div>{{{sources}}}
</main></body>
</html>
""";
    }

    private static IReadOnlyList<JsonElement> Blocks(JsonElement document) =>
        document.TryGetProperty("blocks", out var blocks) && blocks.ValueKind == JsonValueKind.Array
            ? blocks.EnumerateArray().Select(block => block.Clone()).ToList()
            : [];

    private static void AppendRecommendation(StringBuilder html, JsonElement block, string summary)
    {
        var data = Data(block);
        var items = Items(data);
        var winner = items.FirstOrDefault();
        html.Append("<section aria-labelledby=\"winner-title\"><div class=\"section-head\"><div class=\"kicker\">Our pick</div><h2 id=\"winner-title\">")
            .Append(Encode(Text(block, "title", "Best match"))).Append("</h2></div>");
        if (winner.ValueKind != JsonValueKind.Object)
        {
            var text = Text(data, "text", string.Empty);
            if (!string.IsNullOrWhiteSpace(text) && !Same(text, summary))
                html.Append("<div class=\"panel compact\">").Append(Encode(text)).Append("</div>");
            html.Append("</section>");
            return;
        }

        var label = Text(winner, "label", "Recommended option");
        var imageUrl = HttpsUrl(winner, "imageUrl");
        html.Append("<article class=\"panel winner\">");
        if (imageUrl is not null)
            html.Append("<div class=\"winner-media\"><img loading=\"eager\" width=\"640\" height=\"400\" src=\"")
                .Append(Encode(imageUrl)).Append("\" alt=\"").Append(Encode(label)).Append("\"></div>");
        html.Append("<div class=\"winner-body\"><h3>").Append(Encode(label)).Append("</h3>");
        AppendValueAndDetail(html, winner);
        var textContent = Text(data, "text", string.Empty);
        if (!string.IsNullOrWhiteSpace(textContent) && !Same(textContent, summary))
            html.Append("<p class=\"description\">").Append(Encode(textContent)).Append("</p>");
        AppendMetrics(html, Metrics(data));
        AppendActions(html, winner, true);
        html.Append("</div></article>");

        if (items.Count > 1)
        {
            html.Append("<section aria-labelledby=\"shortlist-title\"><div class=\"section-head\"><div class=\"kicker\">Shortlist</div><h2 id=\"shortlist-title\">")
                .Append(Encode("Also consider")).Append("</h2></div><div class=\"products\">");
            foreach (var item in items.Skip(1))
                AppendProduct(html, item);
            html.Append("</div></section>");
        }

        html.Append("</section>");
    }

    private static void AppendComparison(StringBuilder html, JsonElement block)
    {
        var data = Data(block);
        var items = Items(data);
        if (items.Count == 0) return;
        html.Append("<section aria-labelledby=\"compare-title\"><div class=\"section-head\"><div class=\"kicker\">Shortlist</div><h2 id=\"compare-title\">")
            .Append(Encode(Text(block, "title", "Compare the best options"))).Append("</h2>");
        var text = Text(data, "text", string.Empty);
        if (!string.IsNullOrWhiteSpace(text)) html.Append("<p class=\"section-copy\">").Append(Encode(text)).Append("</p>");
        html.Append("</div><div class=\"products\">");
        foreach (var item in items) AppendProduct(html, item);
        html.Append("</div></section>");
    }

    private static void AppendProduct(StringBuilder html, JsonElement item)
    {
        var label = Text(item, "label", "Product");
        var imageUrl = HttpsUrl(item, "imageUrl");
        html.Append(imageUrl is null ? "<article class=\"panel product no-image\">" : "<article class=\"panel product\">");
        if (imageUrl is not null)
            html.Append("<div class=\"product-media\"><img loading=\"lazy\" width=\"480\" height=\"300\" src=\"")
                .Append(Encode(imageUrl)).Append("\" alt=\"").Append(Encode(label)).Append("\"></div>");
        html.Append("<div class=\"product-body\"><h3>").Append(Encode(label)).Append("</h3>");
        AppendValueAndDetail(html, item);
        AppendActions(html, item, false);
        html.Append("</div></article>");
    }

    private static void AppendActions(StringBuilder html, JsonElement item, bool featured)
    {
        var actions = item.TryGetProperty("actions", out var values) && values.ValueKind == JsonValueKind.Array
            ? values.EnumerateArray().Take(3).ToList()
            : [];
        if (actions.Count == 0)
        {
            var legacyUrl = HttpsUrl(item, "url");
            if (legacyUrl is null) return;
            var legacyLabel = Text(item, "actionLabel", "View product");
            html.Append("<div class=\"offers\"><div class=\"offer\"><div><span class=\"store\">Product page</span></div>");
            AppendActionLink(html, legacyUrl, legacyLabel, featured, "Product page");
            html.Append("</div></div>");
            return;
        }

        html.Append("<div class=\"offers\">");
        var index = 0;
        foreach (var action in actions)
        {
            var url = HttpsUrl(action, "url");
            if (url is null) continue;
            var store = Text(action, "storeName", StoreFromUrl(url));
            var label = Text(action, "label", "View offer");
            var availability = Text(action, "availability", string.Empty);
            html.Append("<div class=\"offer\"><div><span class=\"store\">").Append(Encode(store)).Append("</span>");
            if (!string.IsNullOrWhiteSpace(availability))
                html.Append("<span class=\"availability\">").Append(Encode(availability)).Append("</span>");
            html.Append("</div>");
            AppendActionLink(html, url, label, featured && index == 0, store);
            html.Append("</div>");
            index++;
        }
        html.Append("</div>");
    }

    private static void AppendActionLink(
        StringBuilder html,
        string url,
        string label,
        bool primary,
        string store)
    {
        html.Append(primary ? "<a class=\"action primary\"" : "<a class=\"action\"")
            .Append(" target=\"_blank\" rel=\"noopener noreferrer\" aria-label=\"")
            .Append(Encode($"{label} at {store}")).Append("\" href=\"")
            .Append(Encode(url)).Append("\">").Append(Encode(label)).Append("</a>");
    }

    private static void AppendCompactSection(StringBuilder html, JsonElement block, string modifier)
    {
        var data = Data(block);
        var text = Text(data, "text", string.Empty);
        var items = Items(data);
        var metrics = Metrics(data);
        if (string.IsNullOrWhiteSpace(text) && items.Count == 0 && metrics.Count == 0) return;
        html.Append("<section class=\"panel compact ").Append(modifier).Append("\"><h2>")
            .Append(Encode(Text(block, "title", "What to know"))).Append("</h2>");
        if (!string.IsNullOrWhiteSpace(text)) html.Append("<p class=\"section-copy\">").Append(Encode(text)).Append("</p>");
        AppendPlainItems(html, items);
        AppendMetrics(html, metrics);
        html.Append("</section>");
    }

    private static void AppendDisclosure(StringBuilder html, JsonElement block, string fallbackTitle)
    {
        var data = Data(block);
        var text = Text(data, "text", string.Empty);
        var items = Items(data);
        var metrics = Metrics(data);
        if (string.IsNullOrWhiteSpace(text) && items.Count == 0 && metrics.Count == 0) return;
        html.Append("<details><summary>").Append(Encode(Text(block, "title", fallbackTitle)))
            .Append("</summary><div class=\"detail-body\">");
        if (!string.IsNullOrWhiteSpace(text)) html.Append("<p class=\"section-copy\">").Append(Encode(text)).Append("</p>");
        AppendPlainItems(html, items);
        AppendMetrics(html, metrics);
        html.Append("</div></details>");
    }

    private static void AppendPlainItems(StringBuilder html, IReadOnlyList<JsonElement> items)
    {
        if (items.Count == 0) return;
        html.Append("<div class=\"items\">");
        foreach (var item in items)
        {
            html.Append("<div class=\"plain-item\"><strong>").Append(Encode(Text(item, "label", "Item"))).Append("</strong>");
            var value = Text(item, "value", string.Empty);
            var detail = Text(item, "detail", string.Empty);
            if (!string.IsNullOrWhiteSpace(value)) html.Append("<div class=\"item-value\">").Append(Encode(value)).Append("</div>");
            if (!string.IsNullOrWhiteSpace(detail)) html.Append("<div class=\"item-detail\">").Append(Encode(detail)).Append("</div>");
            html.Append("</div>");
        }
        html.Append("</div>");
    }

    private static void AppendMetrics(StringBuilder html, IReadOnlyList<JsonElement> metrics)
    {
        if (metrics.Count == 0) return;
        html.Append("<div class=\"metrics\">");
        foreach (var metric in metrics)
        {
            var label = Text(metric, "label", "Score");
            var value = Number(metric, "value");
            var maximum = Math.Max(Number(metric, "maximum"), 1);
            var percentage = Math.Clamp(value / maximum * 100, 0, 100);
            html.Append("<div class=\"metric\"><div class=\"metric-head\"><span>")
                .Append(Encode(label)).Append("</span><strong>")
                .Append(value.ToString("0.#", CultureInfo.InvariantCulture)).Append(" / ")
                .Append(maximum.ToString("0.#", CultureInfo.InvariantCulture))
                .Append("</strong></div><div class=\"track\" role=\"img\" aria-label=\"")
                .Append(Encode($"{label}: {value:0.#} out of {maximum:0.#}"))
                .Append("\"><div class=\"fill\" style=\"width:")
                .Append(percentage.ToString("0.#", CultureInfo.InvariantCulture)).Append("%\"></div></div></div>");
        }
        html.Append("</div>");
    }

    private static string RenderSources(JsonElement document)
    {
        if (!document.TryGetProperty("sources", out var values) || values.ValueKind != JsonValueKind.Array)
            return string.Empty;
        var sources = values.EnumerateArray().ToList();
        if (sources.Count == 0) return string.Empty;
        var html = new StringBuilder("<details class=\"sources\"><summary>Sources used (")
            .Append(sources.Count).Append(")</summary><div class=\"detail-body\"><ol>");
        foreach (var source in sources)
        {
            var title = Text(source, "title", "Source");
            var publisher = Text(source, "publisher", string.Empty);
            var url = HttpsUrl(source, "url");
            html.Append("<li>");
            if (url is null) html.Append(Encode(title));
            else html.Append("<a target=\"_blank\" rel=\"noopener noreferrer\" href=\"")
                .Append(Encode(url)).Append("\">").Append(Encode(title)).Append("</a>");
            if (!string.IsNullOrWhiteSpace(publisher)) html.Append(" · ").Append(Encode(publisher));
            html.Append("</li>");
        }
        return html.Append("</ol></div></details>").ToString();
    }

    private static JsonElement Data(JsonElement block) =>
        block.TryGetProperty("data", out var data) && data.ValueKind == JsonValueKind.Object ? data : default;

    private static IReadOnlyList<JsonElement> Items(JsonElement data) =>
        data.ValueKind == JsonValueKind.Object && data.TryGetProperty("items", out var items) && items.ValueKind == JsonValueKind.Array
            ? items.EnumerateArray().Select(item => item.Clone()).ToList()
            : [];

    private static IReadOnlyList<JsonElement> Metrics(JsonElement data) =>
        data.ValueKind == JsonValueKind.Object && data.TryGetProperty("metrics", out var metrics) && metrics.ValueKind == JsonValueKind.Array
            ? metrics.EnumerateArray().Select(metric => metric.Clone()).ToList()
            : [];

    private static void AppendValueAndDetail(StringBuilder html, JsonElement item)
    {
        var value = Text(item, "value", string.Empty);
        var detail = Text(item, "detail", string.Empty);
        if (!string.IsNullOrWhiteSpace(value)) html.Append("<div class=\"winner-price\">").Append(Encode(value)).Append("</div>");
        if (!string.IsNullOrWhiteSpace(detail)) html.Append("<p class=\"description\">").Append(Encode(detail)).Append("</p>");
    }

    private static string Type(JsonElement block) => Text(block, "type", "section");

    private static string Text(JsonElement element, string property, string fallback) =>
        element.ValueKind == JsonValueKind.Object &&
        element.TryGetProperty(property, out var value) && value.ValueKind == JsonValueKind.String
            ? value.GetString() ?? fallback
            : fallback;

    private static double Number(JsonElement element, string property) =>
        element.TryGetProperty(property, out var value) && value.TryGetDouble(out var number) ? number : 0;

    private static string? HttpsUrl(JsonElement element, string property)
    {
        var value = Text(element, property, string.Empty);
        return Uri.TryCreate(value, UriKind.Absolute, out var uri) && uri.Scheme == Uri.UriSchemeHttps
            ? uri.AbsoluteUri
            : null;
    }

    private static string StoreFromUrl(string url)
    {
        if (!Uri.TryCreate(url, UriKind.Absolute, out var uri)) return "Store";
        return uri.Host.StartsWith("www.", StringComparison.OrdinalIgnoreCase)
            ? uri.Host[4..]
            : uri.Host;
    }

    private static bool Same(string left, string right) =>
        left.Trim().Equals(right.Trim(), StringComparison.OrdinalIgnoreCase);

    private static string Encode(string value) => WebUtility.HtmlEncode(value);
}
