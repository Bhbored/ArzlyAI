using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ArzlyAI.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AdminAuthoredPresetCatalog : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // This is intentionally a one-time, key-scoped cleanup. Preset startup
            // seeds were removed, so these rows cannot be recreated on restart.
            migrationBuilder.Sql("""
                DELETE FROM "Presets"
                WHERE "Key" IN (
                    'daily-linkedin-ai-post',
                    'smart-purchase-decision',
                    'brain-dump-to-action',
                    'receipt-intelligence',
                    'receipt-monthly-spending',
                    'receipt-weekly-budget',
                    'receipt-quarterly-tax',
                    'receipt-yearly-review',
                    'receipt-category-dive',
                    'receipt-anomaly-detector',
                    'receipt-savings-tracker');
                """);

            migrationBuilder.DropColumn(
                name: "IsPublished",
                table: "Presets");

            migrationBuilder.AddColumn<string>(
                name: "Key",
                table: "PresetWorkflowSteps",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "AllowedTriggerTypesJson",
                table: "Presets",
                type: "jsonb",
                nullable: false,
                defaultValue: "[]");

            migrationBuilder.AddColumn<DateTimeOffset>(
                name: "ArchivedAtUtc",
                table: "Presets",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "BackgroundExecutionMode",
                table: "Presets",
                type: "text",
                nullable: false,
                defaultValue: "NotApplicable");

            migrationBuilder.AddColumn<string>(
                name: "BackgroundExecutionRationale",
                table: "Presets",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "DetailedDescription",
                table: "Presets",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<DateTimeOffset>(
                name: "PublishedAtUtc",
                table: "Presets",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "PublishedByAdminId",
                table: "Presets",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Status",
                table: "Presets",
                type: "text",
                nullable: false,
                defaultValue: "Archived");

            migrationBuilder.AddColumn<string>(
                name: "Subtitle",
                table: "Presets",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "SupersedesPresetId",
                table: "Presets",
                type: "uuid",
                nullable: true);

            migrationBuilder.Sql("""
                ALTER TABLE "Integrations"
                ALTER COLUMN "CredentialSchemaJson" TYPE jsonb
                USING "CredentialSchemaJson"::jsonb;
                """);

            migrationBuilder.AddColumn<Guid>(
                name: "ConnectorId",
                table: "Integrations",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "DocumentationLinksJson",
                table: "Integrations",
                type: "jsonb",
                nullable: false,
                defaultValue: "[]");

            migrationBuilder.AddColumn<string>(
                name: "InputSchemaJson",
                table: "Integrations",
                type: "jsonb",
                nullable: false,
                defaultValue: "{}");

            migrationBuilder.AddColumn<string>(
                name: "OutputSchemaJson",
                table: "Integrations",
                type: "jsonb",
                nullable: false,
                defaultValue: "{}");

            migrationBuilder.AddColumn<string>(
                name: "RequiredApisJson",
                table: "Integrations",
                type: "jsonb",
                nullable: false,
                defaultValue: "[]");

            migrationBuilder.AddColumn<string>(
                name: "RequiredOAuthScopesJson",
                table: "Integrations",
                type: "jsonb",
                nullable: false,
                defaultValue: "[]");

            migrationBuilder.AddColumn<string>(
                name: "RiskLevel",
                table: "Integrations",
                type: "text",
                nullable: false,
                defaultValue: "Read");

            migrationBuilder.AddColumn<bool>(
                name: "SupportsBackgroundExecution",
                table: "Integrations",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.CreateTable(
                name: "AdminAccounts",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Email = table.Column<string>(type: "character varying(320)", maxLength: 320, nullable: false),
                    NormalizedEmail = table.Column<string>(type: "character varying(320)", maxLength: 320, nullable: false),
                    DisplayName = table.Column<string>(type: "text", nullable: false),
                    PasswordHash = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: false),
                    SecurityStamp = table.Column<string>(type: "text", nullable: false),
                    IsEnabled = table.Column<bool>(type: "boolean", nullable: false),
                    FailedLoginCount = table.Column<int>(type: "integer", nullable: false),
                    LockoutEndUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    UpdatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AdminAccounts", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "AdminInvitations",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Email = table.Column<string>(type: "text", nullable: false),
                    NormalizedEmail = table.Column<string>(type: "character varying(320)", maxLength: 320, nullable: false),
                    TokenHash = table.Column<string>(type: "character varying(64)", maxLength: 64, nullable: false),
                    CreatedByAdminId = table.Column<Guid>(type: "uuid", nullable: false),
                    ExpiresAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    AcceptedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    UpdatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AdminInvitations", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Connectors",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Key = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    DisplayName = table.Column<string>(type: "text", nullable: false),
                    Description = table.Column<string>(type: "text", nullable: false),
                    AuthenticationType = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    IsEnabled = table.Column<bool>(type: "boolean", nullable: false),
                    CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    UpdatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Connectors", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "PresetAdminNotes",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    PresetId = table.Column<Guid>(type: "uuid", nullable: false),
                    Title = table.Column<string>(type: "text", nullable: false),
                    Description = table.Column<string>(type: "text", nullable: false),
                    Severity = table.Column<string>(type: "text", nullable: false),
                    LinksJson = table.Column<string>(type: "jsonb", nullable: false),
                    DisplayOrder = table.Column<int>(type: "integer", nullable: false),
                    CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    UpdatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PresetAdminNotes", x => x.Id);
                    table.ForeignKey(
                        name: "FK_PresetAdminNotes_Presets_PresetId",
                        column: x => x.PresetId,
                        principalTable: "Presets",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "PresetAuthoringSessions",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    CreatedByAdminId = table.Column<Guid>(type: "uuid", nullable: false),
                    Title = table.Column<string>(type: "text", nullable: true),
                    Status = table.Column<string>(type: "text", nullable: false),
                    DraftJson = table.Column<string>(type: "jsonb", nullable: true),
                    ValidationJson = table.Column<string>(type: "jsonb", nullable: false),
                    Revision = table.Column<int>(type: "integer", nullable: false),
                    PublishedPresetId = table.Column<Guid>(type: "uuid", nullable: true),
                    CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    UpdatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PresetAuthoringSessions", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "WorkflowOperations",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Key = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    DisplayName = table.Column<string>(type: "text", nullable: false),
                    Description = table.Column<string>(type: "text", nullable: false),
                    InputSchemaJson = table.Column<string>(type: "jsonb", nullable: false),
                    OutputSchemaJson = table.Column<string>(type: "jsonb", nullable: false),
                    SupportsBackgroundExecution = table.Column<bool>(type: "boolean", nullable: false),
                    IsEnabled = table.Column<bool>(type: "boolean", nullable: false),
                    CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    UpdatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_WorkflowOperations", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "AdminRefreshSessions",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    AdminAccountId = table.Column<Guid>(type: "uuid", nullable: false),
                    FamilyId = table.Column<Guid>(type: "uuid", nullable: false),
                    TokenHash = table.Column<string>(type: "character varying(64)", maxLength: 64, nullable: false),
                    ExpiresAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    RevokedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    ReplacedByTokenHash = table.Column<string>(type: "character varying(64)", maxLength: 64, nullable: true),
                    CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    UpdatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AdminRefreshSessions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AdminRefreshSessions_AdminAccounts_AdminAccountId",
                        column: x => x.AdminAccountId,
                        principalTable: "AdminAccounts",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "PresetAuthoringMessages",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    SessionId = table.Column<Guid>(type: "uuid", nullable: false),
                    Sequence = table.Column<int>(type: "integer", nullable: false),
                    Role = table.Column<string>(type: "text", nullable: false),
                    Content = table.Column<string>(type: "text", nullable: false),
                    ToolName = table.Column<string>(type: "text", nullable: true),
                    ToolPayloadJson = table.Column<string>(type: "jsonb", nullable: true),
                    CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    UpdatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PresetAuthoringMessages", x => x.Id);
                    table.ForeignKey(
                        name: "FK_PresetAuthoringMessages_PresetAuthoringSessions_SessionId",
                        column: x => x.SessionId,
                        principalTable: "PresetAuthoringSessions",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.Sql("""
                UPDATE "PresetWorkflowSteps"
                SET "Key" = trim(both '-' from regexp_replace(lower("ReferenceKey"), '[^a-z0-9.-]+', '-', 'g'))
                    || '-' || "Position"::text
                WHERE "Key" = '';
                """);

            migrationBuilder.CreateIndex(
                name: "IX_PresetWorkflowSteps_WorkflowId_Key",
                table: "PresetWorkflowSteps",
                columns: new[] { "WorkflowId", "Key" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Presets_Key",
                table: "Presets",
                column: "Key",
                unique: true,
                filter: "\"Status\" = 'Published'");

            migrationBuilder.CreateIndex(
                name: "IX_Integrations_ConnectorId",
                table: "Integrations",
                column: "ConnectorId");

            migrationBuilder.CreateIndex(
                name: "IX_AdminAccounts_NormalizedEmail",
                table: "AdminAccounts",
                column: "NormalizedEmail",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_AdminInvitations_TokenHash",
                table: "AdminInvitations",
                column: "TokenHash",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_AdminRefreshSessions_AdminAccountId",
                table: "AdminRefreshSessions",
                column: "AdminAccountId");

            migrationBuilder.CreateIndex(
                name: "IX_AdminRefreshSessions_TokenHash",
                table: "AdminRefreshSessions",
                column: "TokenHash",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Connectors_Key",
                table: "Connectors",
                column: "Key",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_PresetAdminNotes_PresetId",
                table: "PresetAdminNotes",
                column: "PresetId");

            migrationBuilder.CreateIndex(
                name: "IX_PresetAuthoringMessages_SessionId_Sequence",
                table: "PresetAuthoringMessages",
                columns: new[] { "SessionId", "Sequence" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_WorkflowOperations_Key",
                table: "WorkflowOperations",
                column: "Key",
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Integrations_Connectors_ConnectorId",
                table: "Integrations",
                column: "ConnectorId",
                principalTable: "Connectors",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Integrations_Connectors_ConnectorId",
                table: "Integrations");

            migrationBuilder.DropTable(
                name: "AdminInvitations");

            migrationBuilder.DropTable(
                name: "AdminRefreshSessions");

            migrationBuilder.DropTable(
                name: "Connectors");

            migrationBuilder.DropTable(
                name: "PresetAdminNotes");

            migrationBuilder.DropTable(
                name: "PresetAuthoringMessages");

            migrationBuilder.DropTable(
                name: "WorkflowOperations");

            migrationBuilder.DropTable(
                name: "AdminAccounts");

            migrationBuilder.DropTable(
                name: "PresetAuthoringSessions");

            migrationBuilder.DropIndex(
                name: "IX_PresetWorkflowSteps_WorkflowId_Key",
                table: "PresetWorkflowSteps");

            migrationBuilder.DropIndex(
                name: "IX_Presets_Key",
                table: "Presets");

            migrationBuilder.DropIndex(
                name: "IX_Integrations_ConnectorId",
                table: "Integrations");

            migrationBuilder.DropColumn(
                name: "Key",
                table: "PresetWorkflowSteps");

            migrationBuilder.DropColumn(
                name: "AllowedTriggerTypesJson",
                table: "Presets");

            migrationBuilder.DropColumn(
                name: "ArchivedAtUtc",
                table: "Presets");

            migrationBuilder.DropColumn(
                name: "BackgroundExecutionMode",
                table: "Presets");

            migrationBuilder.DropColumn(
                name: "BackgroundExecutionRationale",
                table: "Presets");

            migrationBuilder.DropColumn(
                name: "DetailedDescription",
                table: "Presets");

            migrationBuilder.DropColumn(
                name: "PublishedAtUtc",
                table: "Presets");

            migrationBuilder.DropColumn(
                name: "PublishedByAdminId",
                table: "Presets");

            migrationBuilder.DropColumn(
                name: "Status",
                table: "Presets");

            migrationBuilder.DropColumn(
                name: "Subtitle",
                table: "Presets");

            migrationBuilder.DropColumn(
                name: "SupersedesPresetId",
                table: "Presets");

            migrationBuilder.DropColumn(
                name: "ConnectorId",
                table: "Integrations");

            migrationBuilder.DropColumn(
                name: "DocumentationLinksJson",
                table: "Integrations");

            migrationBuilder.DropColumn(
                name: "InputSchemaJson",
                table: "Integrations");

            migrationBuilder.DropColumn(
                name: "OutputSchemaJson",
                table: "Integrations");

            migrationBuilder.DropColumn(
                name: "RequiredApisJson",
                table: "Integrations");

            migrationBuilder.DropColumn(
                name: "RequiredOAuthScopesJson",
                table: "Integrations");

            migrationBuilder.DropColumn(
                name: "RiskLevel",
                table: "Integrations");

            migrationBuilder.DropColumn(
                name: "SupportsBackgroundExecution",
                table: "Integrations");

            migrationBuilder.AddColumn<bool>(
                name: "IsPublished",
                table: "Presets",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.Sql("""
                ALTER TABLE "Integrations"
                ALTER COLUMN "CredentialSchemaJson" TYPE text
                USING "CredentialSchemaJson"::text;
                """);
        }
    }
}
