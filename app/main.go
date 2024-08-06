package main

import (
	"fmt"
	"net/http"
	"os"
)

func helloHandler(w http.ResponseWriter, r *http.Request) {
	// Read environment variables
	username := os.Getenv("USERNAME")
	password := os.Getenv("PASSWORD")
	
	// Print to HTTP response
	fmt.Fprintf(w, "Hello, World!\n")
	fmt.Fprintf(w, "Username: %s\n", username)
	fmt.Fprintf(w, "Password: %s\n", password)
}

func main() {
	http.HandleFunc("/", helloHandler)
	fmt.Println("Starting server on :8080")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		fmt.Println("Error starting server:", err)
	}
}