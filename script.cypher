
// Requete permettant de crée un noeud correspondant a une entreprise
CREATE (e:Company {
  name: 'Company Name',
  industry: 'Industry',
  description: 'Company Description',
  size: 'Company Size'
});

CREATE INDEX ON :Company(name)


// Requete permettant de crée un noeud correspondant a un utilisateur
CREATE (u:User {
  name: 'User Last Name',
  first_name: 'User First Name',
  description: 'User Description',
  skills: ['List', 'of', 'skills']
});


CREATE INDEX ON :User(name)



// Requete permettant de crée une relation entre un utilisateur et une entreprise par rapport a une durée de travail
MATCH (u:User { name: 'User Last Name' }), (e:Company { name: 'Company Name' })
CREATE (u)-[:WORKED_FOR {  from: 'Start Date',  to: 'End Date',  position: 'Job Position (employee, contractor)'}]->(e);

// Crée une relation entre deux utilisateurs qui ont travaillé ensemble
MATCH (u1:User { name: 'User Last Name 1' }), (u2:User { name: 'User Last Name 2' })
CREATE (u1)-[:WORKED_WITH]->(u2);

// Crée une relation entre deux utilisateurs qui se connaissent
MATCH (u1:User { name: 'User Last Name 1' }), (u2:User { name: 'User Last Name 2' })
CREATE (u1)-[:KNOWS]->(u2);


// Requete permettant de trouver une entreprise par son nom
MATCH (e:Company)
WHERE e.name CONTAINS 'Company Name'
RETURN e;


// la meme chose pour les utilisateur
MATCH (u:User)
WHERE u.name CONTAINS 'User Last Name'
RETURN u;



// Requete permettant de trouver un utilisateur ayant travaillé pour une entreprise
MATCH (u1:User)-[r1:WORKED_FOR]->(e:Company)<-[r2:WORKED_FOR]-(u2:User)
WHERE u1.name = 'Given User Last Name' AND e.name = 'Given Company Name'
AND r1.from <= r2.to AND r1.to >= r2.from
RETURN u2;


// Trouver les utilisateurs qui connaissent un utilisateur donné
MATCH (u1:User)-[:KNOWS]->(u2:User)
WHERE u1.name = 'Given User Last Name'
RETURN u2;


