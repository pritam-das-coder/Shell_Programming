#!/bin/bash
#function greet {
#    echo "Hello, $1"
#}
#greet "Alice"
function display {
    echo "First argument: $1"
    echo "Second argument: $2"
    echo "Total arguments passed: $#"
    echo "All arguments: $@"
}
display "Alice" "Bob" "Charlie" 12
