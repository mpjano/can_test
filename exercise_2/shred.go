package main

import (
	"fmt"
	"log"
	"math/rand"
	"os"
	"time"
)

func main() {
	var path string
	_, err := fmt.Scan(&path)
	if err != nil {
		fmt.Println(err)
	} else {
		Shred(path)
	}
}

func Shred(path string) {

	f, err := os.OpenFile(path, os.O_RDWR, 0x644)
	if err != nil {
		log.Fatal(err)
	}

	defer func() {
		if err := f.Close(); err != nil {
			log.Fatal(err)
		}
	}()

	f_info, err := f.Stat()
	if err != nil {
		log.Fatal(err)
	}

	for j := 0; j < 3; j++ {
		// make a random buffer
		rand.Seed(time.Now().UnixNano())
		buf := make([]byte, f_info.Size())
		rand.Read(buf)

		f.Truncate(0)
		f.Seek(0, 0)

		// write
		if _, err := f.Write(buf); err != nil {
			panic(err)
		}
	}

	if err := os.Remove(path); err != nil {
		log.Fatal(err)
	}
}
