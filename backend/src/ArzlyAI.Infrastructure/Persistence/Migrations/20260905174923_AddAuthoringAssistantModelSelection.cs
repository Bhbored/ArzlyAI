using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ArzlyAI.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddAuthoringAssistantModelSelection : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "AssistantModel",
                table: "PresetAuthoringSessions",
                type: "character varying(160)",
                maxLength: 160,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "AssistantProvider",
                table: "PresetAuthoringSessions",
                type: "character varying(32)",
                maxLength: 32,
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "AssistantModel",
                table: "PresetAuthoringSessions");

            migrationBuilder.DropColumn(
                name: "AssistantProvider",
                table: "PresetAuthoringSessions");
        }
    }
}
