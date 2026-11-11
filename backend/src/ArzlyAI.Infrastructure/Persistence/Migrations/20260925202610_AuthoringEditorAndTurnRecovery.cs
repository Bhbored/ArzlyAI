using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ArzlyAI.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AuthoringEditorAndTurnRecovery : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "DraftRevision",
                table: "PresetAuthoringSessions",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "LastTurnError",
                table: "PresetAuthoringSessions",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "LastTurnId",
                table: "PresetAuthoringSessions",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "LastTurnStatus",
                table: "PresetAuthoringSessions",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<DateTimeOffset>(
                name: "TurnStartedAtUtc",
                table: "PresetAuthoringSessions",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "ValidatedDraftRevision",
                table: "PresetAuthoringSessions",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "ClientRequestId",
                table: "PresetAuthoringMessages",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "TurnId",
                table: "PresetAuthoringMessages",
                type: "uuid",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_PresetAuthoringMessages_SessionId_ClientRequestId",
                table: "PresetAuthoringMessages",
                columns: new[] { "SessionId", "ClientRequestId" },
                unique: true);

            migrationBuilder.Sql("""
                UPDATE "PresetAuthoringSessions"
                SET "DraftRevision" = 1,
                    "ValidatedDraftRevision" = CASE WHEN "Status" = 'ReadyToPublish' THEN 1 ELSE NULL END
                WHERE "DraftJson" IS NOT NULL;
                """);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_PresetAuthoringMessages_SessionId_ClientRequestId",
                table: "PresetAuthoringMessages");

            migrationBuilder.DropColumn(
                name: "DraftRevision",
                table: "PresetAuthoringSessions");

            migrationBuilder.DropColumn(
                name: "LastTurnError",
                table: "PresetAuthoringSessions");

            migrationBuilder.DropColumn(
                name: "LastTurnId",
                table: "PresetAuthoringSessions");

            migrationBuilder.DropColumn(
                name: "LastTurnStatus",
                table: "PresetAuthoringSessions");

            migrationBuilder.DropColumn(
                name: "TurnStartedAtUtc",
                table: "PresetAuthoringSessions");

            migrationBuilder.DropColumn(
                name: "ValidatedDraftRevision",
                table: "PresetAuthoringSessions");

            migrationBuilder.DropColumn(
                name: "ClientRequestId",
                table: "PresetAuthoringMessages");

            migrationBuilder.DropColumn(
                name: "TurnId",
                table: "PresetAuthoringMessages");
        }
    }
}
