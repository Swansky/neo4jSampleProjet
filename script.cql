CREATE (e:Company {
  name: 'Company Name',
  industry: 'Industry',
  description: 'Company Description',
  size: 'Company Size'
});

CREATE (u:User {
  name: 'User Last Name',
  first_name: 'User First Name',
  description: 'User Description',
  skills: ['List', 'of', 'skills']
});


# create relation

MATCH (u:User { name: 'User Last Name' }), (e:Company { name: 'Company Name' })
CREATE (u)-[:WORKED_FOR {  from: 'Start Date',  to: 'End Date',  position: 'Job Position (employee, contractor)'}]->(e);

MATCH (u1:User { name: 'User Last Name 1' }), (u2:User { name: 'User Last Name 2' })
CREATE (u1)-[:WORKED_WITH]->(u2);

MATCH (u1:User { name: 'User Last Name 1' }), (u2:User { name: 'User Last Name 2' })
CREATE (u1)-[:KNOWS]->(u2);


# search company by name

MATCH (e:Company)
WHERE e.name CONTAINS 'Company Name'
RETURN e;


#search user by name

MATCH (u:User)
WHERE u.name CONTAINS 'User Last Name'
RETURN u;



# Users who worked with a given user at a specific company 

MATCH (u1:User)-[r1:WORKED_FOR]->(e:Company)<-[r2:WORKED_FOR]-(u2:User)
WHERE u1.name = 'Given User Last Name' AND e.name = 'Given Company Name'
AND r1.from <= r2.to AND r1.to >= r2.from
RETURN u2;

# Users known by the connections of a given user

MATCH (u1:User)-[:KNOWS]->(u2:User)
WHERE u1.name = 'Given User Last Name'
RETURN u2;


