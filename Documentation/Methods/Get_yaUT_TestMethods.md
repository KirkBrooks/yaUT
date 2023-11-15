<!-- Type your summary here -->
## Description

This method scans your database for project methods beginning with ‘yaut_’ and returns a collection of them. Each element of the collection is an object:

```json
{ method: "methodName"; selected: True}
```



This is used in the Main Dialog to allow you to choose which methods to run. 

## Example

```4d
$methods:=Get_uaUT_TestMethods
```

You can run these methods by passing the collection to Run_yaUT_TestMethods.
