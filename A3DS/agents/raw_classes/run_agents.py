import autogen

# Initialize agents
knowledge_base = autogen.KnowledgeBase(data_source="azure")
agent1 = Agent1(knowledge_base)

ticketing_tool = autogen.TicketingTool(api_endpoint="https://ticketing.example.com/api")
agent2 = Agent2(ticketing_tool)

agent3 = Agent3()

# Start agents
autogen.run([agent1, agent2, agent3])