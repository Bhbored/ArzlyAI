using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ArzlyAI.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class InitialPostgreSqlCatalog : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Integrations",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Key = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    DisplayName = table.Column<string>(type: "text", nullable: false),
                    Description = table.Column<string>(type: "text", nullable: false),
                    CredentialSchemaJson = table.Column<string>(type: "text", nullable: false),
                    IsEnabled = table.Column<bool>(type: "boolean", nullable: false),
                    CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    UpdatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Integrations", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Presets",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Key = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Description = table.Column<string>(type: "text", nullable: false),
                    Version = table.Column<int>(type: "integer", nullable: false),
                    IsPublished = table.Column<bool>(type: "boolean", nullable: false),
                    CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    UpdatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Presets", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Providers",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Key = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    DisplayName = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    UpdatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Providers", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "PresetIntegrations",
                columns: table => new
                {
                    PresetId = table.Column<Guid>(type: "uuid", nullable: false),
                    IntegrationId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PresetIntegrations", x => new { x.PresetId, x.IntegrationId });
                    table.ForeignKey(
                        name: "FK_PresetIntegrations_Integrations_IntegrationId",
                        column: x => x.IntegrationId,
                        principalTable: "Integrations",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_PresetIntegrations_Presets_PresetId",
                        column: x => x.PresetId,
                        principalTable: "Presets",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "PresetWorkflows",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    PresetId = table.Column<Guid>(type: "uuid", nullable: false),
                    Key = table.Column<string>(type: "text", nullable: false),
                    CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    UpdatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PresetWorkflows", x => x.Id);
                    table.ForeignKey(
                        name: "FK_PresetWorkflows_Presets_PresetId",
                        column: x => x.PresetId,
                        principalTable: "Presets",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Models",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    ProviderId = table.Column<Guid>(type: "uuid", nullable: false),
                    Key = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    DisplayName = table.Column<string>(type: "text", nullable: false),
                    IsDefault = table.Column<bool>(type: "boolean", nullable: false),
                    CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    UpdatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Models", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Models_Providers_ProviderId",
                        column: x => x.ProviderId,
                        principalTable: "Providers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "PresetWorkflowConnections",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    WorkflowId = table.Column<Guid>(type: "uuid", nullable: false),
                    SourceStepId = table.Column<Guid>(type: "uuid", nullable: false),
                    TargetStepId = table.Column<Guid>(type: "uuid", nullable: false),
                    CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    UpdatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PresetWorkflowConnections", x => x.Id);
                    table.ForeignKey(
                        name: "FK_PresetWorkflowConnections_PresetWorkflows_WorkflowId",
                        column: x => x.WorkflowId,
                        principalTable: "PresetWorkflows",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "PresetWorkflowSteps",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    WorkflowId = table.Column<Guid>(type: "uuid", nullable: false),
                    Position = table.Column<int>(type: "integer", nullable: false),
                    Type = table.Column<string>(type: "text", nullable: false),
                    ReferenceKey = table.Column<string>(type: "text", nullable: false),
                    DisplayName = table.Column<string>(type: "text", nullable: false),
                    InputMappingJson = table.Column<string>(type: "text", nullable: false),
                    RequiresHumanApproval = table.Column<bool>(type: "boolean", nullable: false),
                    CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    UpdatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PresetWorkflowSteps", x => x.Id);
                    table.ForeignKey(
                        name: "FK_PresetWorkflowSteps_PresetWorkflows_WorkflowId",
                        column: x => x.WorkflowId,
                        principalTable: "PresetWorkflows",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "PresetAgents",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    PresetId = table.Column<Guid>(type: "uuid", nullable: false),
                    ModelId = table.Column<Guid>(type: "uuid", nullable: false),
                    Key = table.Column<string>(type: "text", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Instructions = table.Column<string>(type: "text", nullable: false),
                    RuntimeType = table.Column<string>(type: "text", nullable: false),
                    DefaultTemperature = table.Column<double>(type: "double precision", nullable: false),
                    MinimumTemperature = table.Column<double>(type: "double precision", nullable: false),
                    MaximumTemperature = table.Column<double>(type: "double precision", nullable: false),
                    AllowModelOverride = table.Column<bool>(type: "boolean", nullable: false),
                    AllowTemperatureOverride = table.Column<bool>(type: "boolean", nullable: false),
                    CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    UpdatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PresetAgents", x => x.Id);
                    table.ForeignKey(
                        name: "FK_PresetAgents_Models_ModelId",
                        column: x => x.ModelId,
                        principalTable: "Models",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_PresetAgents_Presets_PresetId",
                        column: x => x.PresetId,
                        principalTable: "Presets",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AgentHarnesses",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    AgentId = table.Column<Guid>(type: "uuid", nullable: false),
                    PlanningEnabled = table.Column<bool>(type: "boolean", nullable: false),
                    TodoTrackingEnabled = table.Column<bool>(type: "boolean", nullable: false),
                    ContextCompactionEnabled = table.Column<bool>(type: "boolean", nullable: false),
                    RequireToolApproval = table.Column<bool>(type: "boolean", nullable: false),
                    MaxIterations = table.Column<int>(type: "integer", nullable: false),
                    CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    UpdatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AgentHarnesses", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AgentHarnesses_PresetAgents_AgentId",
                        column: x => x.AgentId,
                        principalTable: "PresetAgents",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_AgentHarnesses_AgentId",
                table: "AgentHarnesses",
                column: "AgentId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Integrations_Key",
                table: "Integrations",
                column: "Key",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Models_ProviderId_Key",
                table: "Models",
                columns: new[] { "ProviderId", "Key" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_PresetAgents_ModelId",
                table: "PresetAgents",
                column: "ModelId");

            migrationBuilder.CreateIndex(
                name: "IX_PresetAgents_PresetId_Key",
                table: "PresetAgents",
                columns: new[] { "PresetId", "Key" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_PresetIntegrations_IntegrationId",
                table: "PresetIntegrations",
                column: "IntegrationId");

            migrationBuilder.CreateIndex(
                name: "IX_Presets_Key_Version",
                table: "Presets",
                columns: new[] { "Key", "Version" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_PresetWorkflowConnections_WorkflowId_SourceStepId_TargetSte~",
                table: "PresetWorkflowConnections",
                columns: new[] { "WorkflowId", "SourceStepId", "TargetStepId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_PresetWorkflows_PresetId",
                table: "PresetWorkflows",
                column: "PresetId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_PresetWorkflowSteps_WorkflowId_Position",
                table: "PresetWorkflowSteps",
                columns: new[] { "WorkflowId", "Position" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Providers_Key",
                table: "Providers",
                column: "Key",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AgentHarnesses");

            migrationBuilder.DropTable(
                name: "PresetIntegrations");

            migrationBuilder.DropTable(
                name: "PresetWorkflowConnections");

            migrationBuilder.DropTable(
                name: "PresetWorkflowSteps");

            migrationBuilder.DropTable(
                name: "PresetAgents");

            migrationBuilder.DropTable(
                name: "Integrations");

            migrationBuilder.DropTable(
                name: "PresetWorkflows");

            migrationBuilder.DropTable(
                name: "Models");

            migrationBuilder.DropTable(
                name: "Presets");

            migrationBuilder.DropTable(
                name: "Providers");
        }
    }
}
