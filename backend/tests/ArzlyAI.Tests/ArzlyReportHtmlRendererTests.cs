using System.Text.Json;
using ArzlyAI.Application.Services.Workflows.Rendering;

namespace ArzlyAI.Tests;

public sealed class ArzlyReportHtmlRendererTests
{
    [Fact]
    public void Render_WhenReportContainsMediaAndLinks_RendersModernSafeHtml()
    {
        using var document = JsonDocument.Parse("""
        {
          "title":"Best <Laptop>",
          "summary":"A safer choice",
          "generatedAtUtc":"2026-08-30T12:00:00Z",
          "blocks":[{
            "type":"recommendation",
            "title":"Winner",
            "data":{
              "text":"Recommended",
              "items":[{
                "label":"Example Pro",
                "value":"$999",
                "detail":"Balanced option",
                "imageUrl":"https://example.com/product.jpg",
                "actions":[{
                  "storeName":"Example Store",
                  "label":"$999 · View offer",
                  "availability":"In stock",
                  "url":"https://example.com/product"
                }]
              }],
              "metrics":[{"label":"Fit","value":92,"maximum":100}]
            }
          }],
          "sources":[{
            "title":"Official source",
            "url":"https://example.com/source",
            "publisher":"Example"
          }]
        }
        """);

        var html = new ArzlyReportHtmlRenderer().Render(document.RootElement);

        Assert.Contains("Best &lt;Laptop&gt;", html, StringComparison.Ordinal);
        Assert.Contains("https://example.com/product.jpg", html, StringComparison.Ordinal);
        Assert.Contains("Example Store", html, StringComparison.Ordinal);
        Assert.Contains("$999", html, StringComparison.Ordinal);
        Assert.Contains("View offer", html, StringComparison.Ordinal);
        Assert.Contains("In stock", html, StringComparison.Ordinal);
        Assert.Contains("Content-Security-Policy", html, StringComparison.Ordinal);
        Assert.Contains("width:92%", html, StringComparison.Ordinal);
    }

    [Fact]
    public void Render_WhenLinkIsNotHttps_DoesNotRenderClickableLink()
    {
        using var document = JsonDocument.Parse("""
        {
          "title":"Decision",
          "summary":"Summary",
          "blocks":[{
            "type":"recommendation",
            "title":"Winner",
            "data":{
              "text":"Recommended",
              "items":[{
                "label":"Unsafe",
                "value":"",
                "detail":"",
                "url":"javascript:alert(1)",
                "imageUrl":"http://example.com/image.jpg",
                "actionLabel":"Open"
              }],
              "metrics":[]
            }
          }],
          "sources":[]
        }
        """);

        var html = new ArzlyReportHtmlRenderer().Render(document.RootElement);

        Assert.DoesNotContain("javascript:", html, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain("http://example.com/image.jpg", html, StringComparison.OrdinalIgnoreCase);
    }
}
