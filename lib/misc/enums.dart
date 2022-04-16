enum Department {
  humanResources("Human Resources", "Responsible for the well-being of people"),
  workplaceResources("Workplace Resources", "Responsible for physical improvements to the workplace"),
  siteTeam("Site Team", "Responsible for everything else");

  const Department(this.name, this.description);
  final String description;
  final String name;
}