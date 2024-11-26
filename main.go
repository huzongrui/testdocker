package main

import (
	"fmt"
	"os"
)

func main() {
	name := os.Getenv("INPUT_NAME")
	if name == "" {
		name = "World"
	}
	fmt.Printf("Hello, %s!\n", name)
}