example_object = {b'Content-Disposition': b'form-data; name="csrfmiddlewaretoken"'}

# Convert the object keys and values to strings
string_object = {key.decode(): value.decode() for key, value in example_object.items()}

# Split the value of Content-Disposition by semicolon and space
disposition_parts = string_object['Content-Disposition'].split('; ')

# Find the part that starts with 'name='
name_part = [part for part in disposition_parts if part.startswith('name=')][0]

# Get the value of name by removing the 'name=' prefix and the surrounding quotes
name_value = name_part.split('=')[1].strip('"')

print(name_value)  # Output: csrfmiddlewaretoken

