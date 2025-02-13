package main

import "fmt"

// ビルド時にldflagsフラグ経由でバージョンを埋め込むための変数
// ex) go build -o example -ldflags "-X main.version=v1.2.3" go/example/main.go
var version string

func main() {
	fmt.Printf("Example %s\n", version)
}
