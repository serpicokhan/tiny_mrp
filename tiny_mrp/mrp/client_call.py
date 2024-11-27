import requests

def get_hozur_count(api_url, start_date, end_date,makan):
    try:
        # Set up the query parameters
        params = {
            'start_date': start_date,
            'end_date': end_date,
            'makan':makan
        }
        # Make the GET request
        response = requests.get(api_url, params=params)
        
        # Check if the request was successful
        if response.status_code == 200:
            return response.json()  # Return the JSON response
        else:
            return {"error": f"API call failed with status code {response.status_code}"}
    except requests.RequestException as e:
        return {"error": str(e)}
