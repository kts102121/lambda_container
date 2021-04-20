import json
import time
import boto3

# Recommendations from Event data
personalize = boto3.client('personalize')
personalize_runtime = boto3.client('personalize-runtime')

# Establish a connection to Personalize's Event Streaming
personalize_events = boto3.client(service_name='personalize-events')

USER_ID = "1"
ITEM_ID = "780"

session_ID = USER_ID

# Configure Properties:
event = {
    "itemId": str(ITEM_ID),
}
event_json = json.dumps(event)
    
# Make Call
personalize_events.put_events(
    trackingId = '86e86267-d221-48de-9a4b-dcb22f58130d',
    userId= USER_ID,
    sessionId = session_ID,
    eventList = [{
        'sentAt': int(time.time()),
        'eventType': 'EVENT_TYPE',
        'properties': event_json
    }]
)