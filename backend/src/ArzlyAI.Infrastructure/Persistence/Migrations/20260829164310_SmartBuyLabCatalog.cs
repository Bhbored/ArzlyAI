using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ArzlyAI.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class SmartBuyLabCatalog : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "ConfigurationJson",
                table: "PresetWorkflowSteps",
                type: "jsonb",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ResultContractKey",
                table: "PresetWorkflowSteps",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "ResultContractVersion",
                table: "PresetWorkflowSteps",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "InputSchemaJson",
                table: "Presets",
                type: "jsonb",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ResultContractKey",
                table: "Presets",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "ResultContractVersion",
                table: "Presets",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "OutputSchemaJson",
                table: "PresetAgents",
                type: "jsonb",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "WebSearchEnabled",
                table: "AgentHarnesses",
                type: "boolean",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ConfigurationJson",
                table: "PresetWorkflowSteps");

            migrationBuilder.DropColumn(
                name: "ResultContractKey",
                table: "PresetWorkflowSteps");

            migrationBuilder.DropColumn(
                name: "ResultContractVersion",
                table: "PresetWorkflowSteps");

            migrationBuilder.DropColumn(
                name: "InputSchemaJson",
                table: "Presets");

            migrationBuilder.DropColumn(
                name: "ResultContractKey",
                table: "Presets");

            migrationBuilder.DropColumn(
                name: "ResultContractVersion",
                table: "Presets");

            migrationBuilder.DropColumn(
                name: "OutputSchemaJson",
                table: "PresetAgents");

            migrationBuilder.DropColumn(
                name: "WebSearchEnabled",
                table: "AgentHarnesses");
        }
    }
}
