// package main

// import (
// 	"fmt"
// 	"os"
// )

//	func main() {
//		name := os.Getenv("INPUT_NAME")
//		if name == "" {
//			name = "World"
//		}
//		fmt.Printf("Hello!, %s!\n", name)
//	}
package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"time"
)

func loggingMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()
		log.Printf("Started %s %s", r.Method, r.RequestURI)
		next.ServeHTTP(w, r)
		log.Printf("Completed %s in %v", r.RequestURI, time.Since(start))
	})
}

func handler(w http.ResponseWriter, r *http.Request) {
	log.Println("Handling request...")
	fmt.Fprintf(w, "Hello, World!")
	log.Println("Request handled.")
}

func main() {
	logFile, err := os.OpenFile("app.log", os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0666)
	if err != nil {
		fmt.Println("Failed to open log file:", err)
		os.Exit(1)
	}
	log.SetOutput(logFile)
	log.Println("Starting server...")

	http.HandleFunc("/", handler)
	http.Handle("/logging", loggingMiddleware(http.HandlerFunc(handler)))

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	log.Printf("Listening on port %s", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatalf("Failed to start server: %s", err)
	}
}
