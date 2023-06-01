from neo4j import GraphDatabase


uri = "bolt://localhost:7687"
username = "neo4j"
password = "exampleexample"

driver = GraphDatabase.driver(uri, auth=(username, password))

# Define functions for executing Cypher queries
def execute_query(query):
    with driver.session() as session:
        result = session.run(query)
        return result


# Data insertion queries
def create_company(name, industry, description, size):
    query = f"CREATE (:Company {{name: '{name}', industry: '{industry}', description: '{description}', size: '{size}'}})"
    execute_query(query)

def create_user(name, first_name, description, skills):
    query = f"CREATE (:User {{name: '{name}', first_name: '{first_name}', description: '{description}', skills: {skills}}})"
    execute_query(query)

def create_worked_for_relation(user_name, company_name, from_date, to_date, position):
    query = f"MATCH (u:User {{name: '{user_name}'}}), (c:Company {{name: '{company_name}'}}) \
              CREATE (u)-[:WORKED_FOR {{from: '{from_date}', to: '{to_date}', position: '{position}'}}]->(c)"
    execute_query(query)

def create_worked_with_relation(user1_name, user2_name):
    query = f"MATCH (u1:User {{name: '{user1_name}'}}), (u2:User {{name: '{user2_name}'}}) \
              CREATE (u1)-[:WORKED_WITH]->(u2)"
    execute_query(query)

def create_knows_relation(user1_name, user2_name):
    query = f"MATCH (u1:User {{name: '{user1_name}'}}), (u2:User {{name: '{user2_name}'}}) \
              CREATE (u1)-[:KNOWS]->(u2)"
    execute_query(query)

# Search queries
def search_company_by_name(name):
    query = f"MATCH (c:Company) WHERE c.name CONTAINS '{name}' RETURN c"
    result = execute_query(query)
    return result

def search_user_by_name(name):
    query = f"MATCH (u:User) WHERE u.name CONTAINS '{name}' RETURN u"
    result = execute_query(query)
    return result

# Suggestions queries
def suggest_users_worked_together(user_name, company_name):
    query = f"MATCH (u1:User)-[r1:WORKED_FOR]->(c:Company)<-[r2:WORKED_FOR]-(u2:User) \
              WHERE u1.name = '{user_name}' AND c.name = '{company_name}' \
              AND r1.from <= r2.to AND r1.to >= r2.from \
              RETURN u2"
    result = execute_query(query)
    return result

def suggest_known_users(user_name):
    query = f"MATCH (u1:User)-[:KNOWS]->(u2:User) \
              WHERE u1.name = '{user_name}' \
              RETURN u2"
    result = execute_query(query)
    return result


create_company("ABC Company", "Technology", "A technology company", "Large")
create_user("John Doe", "John", "Software Engineer", ["Python", "Java", "SQL"])
create_worked_for_relation("John Doe", "ABC Company", "2022-01-01", "2022-12-31", "Employee")
create_user("Jane Smith", "Jane", "Data Scientist", ["Python", "R", "Machine Learning"])
create_worked_for_relation("Jane Smith", "ABC Company", "2022-01-01", "2023-06-30", "Contractor")
create_worked_with_relation("John Doe", "Jane Smith")
create_knows_relation("John Doe", "Jane Smith")


driver.close()
