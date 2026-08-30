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

    [Fact]
    public void Render_WhenRecommendationHasMultipleItems_RendersWinnerAndShortlist()
    {
        using var document = JsonDocument.Parse("""
        {
          "title":"Laptop picks",
          "summary":"Shortlist for Lebanon",
          "blocks":[{
            "type":"recommendation",
            "title":"Our pick",
            "data":{
              "text":"Best overall",
              "items":[
                {
                  "label":"Winner Laptop",
                  "value":"$799",
                  "detail":"Top choice",
                  "imageUrl":"https://example.com/winner.jpg",
                  "actions":[{
                    "storeName":"Local Store",
                    "label":"$799 · View offer",
                    "availability":"In stock",
                    "url":"https://example.com/winner"
                  }]
                },
                {
                  "label":"Alt Laptop",
                  "value":"$749",
                  "detail":"Runner up",
                  "imageUrl":"https://example.com/alt.jpg",
                  "actions":[{
                    "storeName":"Alt Store",
                    "label":"$749 · View offer",
                    "availability":"Limited",
                    "url":"https://example.com/alt"
                  }]
                }
              ],
              "metrics":[]
            }
          }],
          "sources":[]
        }
        """);

        var html = new ArzlyReportHtmlRenderer().Render(document.RootElement);

        Assert.Contains("Winner Laptop", html, StringComparison.Ordinal);
        Assert.Contains("Alt Laptop", html, StringComparison.Ordinal);
        Assert.Contains("Also consider", html, StringComparison.Ordinal);
        Assert.Contains("class=\"products\"", html, StringComparison.Ordinal);
    }
}
