<!-- Type your summary here -->
## Description

This method runs the collection of test methods passed into it. The collection is most easily obtained from Get_yaUT_TestMethods.

The results are returned in a new collection.

## Example

```4d
$tests:=Get_yaUT_TestMethods

$results:=Run_yaUT_TestMethods($tests)
```

Each object in $results will have a ‘displayline’ property that’s a line of text. This is either a text line included in the test method, as a header for example, or it’s the results of the test class. This makes displaying the results in a simple listbox very easy.
