// +build mage

// Build a script to format and run tests of a Terraform module project
package main

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/magefile/mage/mg"
	"github.com/magefile/mage/sh"
)

// The default target when the command executes `mage` in Cloud Shell
var Default = Module

// A build step that runs Clean, Format, Unit and Integration in sequence
// func Full() {
// 	mg.Deps(Unit)
// 	mg.Deps(Integration)
// }

// A build step that runs unit tests
// func Unit() error {
// 	mg.Deps(Clean)
// 	mg.Deps(Format)
// 	fmt.Println("Running unit tests...")
// 	return sh.RunV("go", "test", "./test/", "-run", "TestUT_", "-v")
// }

// A build step that runs module tests
func Module() error {
	mg.Deps(Clean)
	mg.Deps(Format)
	fmt.Println("Running module tests...")
	return sh.RunV("go", "test", "./go/", "-run", "TestMod_", "-v", "-timeout", "30m")
}

// A build step that formats both Terraform code and Go code
func Format() error {
	fmt.Println("Formatting...")
	if err := sh.RunV("terraform", "fmt", "."); err != nil {
		return err
	}
	return sh.RunV("go", "fmt", "./go/")
}

// A build step that removes temporary build and test files
func Clean() error {
	fmt.Println("Cleaning...")
	return filepath.Walk(".", func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if info.IsDir() && info.Name() == "vendor" {
			return filepath.SkipDir
		}
		if info.IsDir() && info.Name() == ".terraform" {
			os.RemoveAll(path)
			fmt.Printf("Removed \"%v\"\n", path)
			return filepath.SkipDir
		}
		if !info.IsDir() && (info.Name() == "terraform.tfstate" ||
			info.Name() == "terraform.tfplan" ||
			info.Name() == "terraform.tfstate.backup") {
			os.Remove(path)
			fmt.Printf("Removed \"%v\"\n", path)
		}
		return nil
	})
}
