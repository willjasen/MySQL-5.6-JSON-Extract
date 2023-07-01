# MySQL 5.6 JSON Extract

## Functions
The function [json_extract_1](json_extract_1.sql) returns the value matching the first key provided within JSON data

The function [json_extract_search](json_extract_search.sql) returns the value matching the first key provided within JSON data

These functions were designed for MySQL 5.6 as it does not include built-in functions to parse JSON data

## Examples

### Example of `json_extract_1`
Given the JSON object in MySQL:
```
DECLARE @json_data TEXT
SET @json_data = '{ "key1": "value1", "key2": "value2", "key3": "value3" }'
```
To return the value related to "key2":
```
json_extract_1(@json_data, 'key2')
```
which returns:
```
value2
```
### Example of `json_extract_search`
Given the JSON object in MySQL:
```
DECLARE @json_data TEXT
SET @json_data =
'{
  {
    "key": "value1",
    "secret_key": "secret_value1"
  },
  {
    "key": "value2",
    "secret_key": "secret_value2"
  },
  {
    "key": "value3",
    "secret_key": "secret_value3"
  },
}'
```
To return the value of "secret_key", dependent on the associated key/pair of "key" and "value2":
```
json_extract_search(@json_data, 'key', 'value2', 'secret_key')
```
which returns:
```
secret_value2
```

## Considerations

* The functions iterate through possibilities and cap out at 99 keypairs for `json_extract_1` and 99 objects for `json_extract_search`
* If more iterations are needed to search more data, the runtime of `json_extract_search` is not expected to be great for very large datasets

## Licensing and Attribution

This project is licensed under the [GPLv3](LICENSE) license

Original license for `json_extract_1` is licensed under the [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) license and is one-way compatible to GPLv3

Original `json_extract_1` function was taken from [@gaborsch](https://github.com/gaborsch) via https://stackoverflow.com/a/52402431

