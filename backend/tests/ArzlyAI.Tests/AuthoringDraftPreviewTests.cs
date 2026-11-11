using System.Text.Json;
using ArzlyAI.Application.Models.Authoring;
using ArzlyAI.Application.DTOs.Admin.Authoring;
using ArzlyAI.Application.Services.Authoring;
using ArzlyAI.Domain.Enums;

namespace ArzlyAI.Tests;

public sealed class AuthoringDraftPreviewTests
{
    [Fact]
    public void SaveAuthoringDraftRequest_WhenEditorSendsEnumNames_DeserializesWithApiDefaults()
    {
        const string body = """
            {"expectedRevision":2,"draft":{"key":"sample","title":"Sample","subtitle":"Sub","description":"Desc",
            "detailedDescription":"Details","inputSchemaJson":"{}","resultContractKey":null,"resultContractVersion":null,
            "backgroundExecution":{"mode":"NotApplicable","rationale":"","allowedTriggerTypes":[]},"agents":[],
            "workflow":{"key":"workflow","nodes":[{"key":"step","displayName":"Step","type":"Operation",
            "referenceKey":"format","position":0,"inputMappingJson":"{}","requiresHumanApproval":false,
            "configurationJson":null,"resultContractKey":null,"resultContractVersion":null,
            "editorPosition":{"x":125.5,"y":240}}],"connections":[]},"adminNotes":[]}}
            """;
        var parsed = JsonSerializer.Deserialize<SaveAuthoringDraftRequest>(body,
            new JsonSerializerOptions(JsonSerializerDefaults.Web));

        Assert.NotNull(parsed);
        Assert.Equal(BackgroundExecutionMode.NotApplicable, parsed.Draft.BackgroundExecution.Mode);
        Assert.Equal(WorkflowNodeType.Operation, parsed.Draft.Workflow.Nodes.Single().Type);
        var savedDraft = PresetDraftSerializer.Deserialize(PresetDraftSerializer.Serialize(parsed.Draft));
        Assert.Equal(new AuthoringCanvasPosition(125.5, 240), savedDraft!.Workflow.Nodes.Single().EditorPosition);
    }

    [Fact]
    public void Build_WhenSampleInputIsMissing_ReportsItWithoutInventingNodeOutput()
    {
        var draft = new PresetDraftDocument("sample", "Sample", "Subtitle", "Description", "Details",
            "{\"type\":\"object\",\"required\":[\"topic\"]}", null, null,
            new BackgroundExecutionPolicyDraft(BackgroundExecutionMode.NotApplicable, "", []), [],
            new PresetDraftWorkflow("workflow", [
                new PresetDraftNode("first", "First", WorkflowNodeType.Agent, "writer", 0,
                    "{\"topic\":\"$.inputs.topic\",\"name\":\"$.literal.demo\"}", false, null, null, null),
                new PresetDraftNode("second", "Second", WorkflowNodeType.Operation, "format", 1,
                    "{\"text\":\"$.nodes.first.output\"}", false, null, null, null)
            ], [new PresetDraftConnection("first", "second")]), []);
        using var sample = JsonDocument.Parse("{}");

        var result = AuthoringDraftPreview.Build(draft, 2, new PresetValidationResult([]), sample.RootElement);

        Assert.Contains(result.Validation.Errors, issue => issue.Path == "inputs.topic");
        Assert.Equal(["first", "second"], result.Nodes.Select(node => node.Key));
        Assert.Equal("Resolved", result.Nodes[0].Inputs.Single(input => input.Input == "name").Status);
        Assert.Equal("RequiresExecution", result.Nodes[1].Inputs.Single().Status);
        Assert.Null(result.Nodes[1].Inputs.Single().Value);
    }
}
