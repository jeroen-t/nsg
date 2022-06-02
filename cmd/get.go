/*
Copyright © 2022 NAME HERE <EMAIL ADDRESS>

*/
package cmd

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"

	"github.com/spf13/cobra"
)

type SecurityRules struct {
	SecurityRules []SecurityRule `json:"securityRules"`
}

type SecurityRule struct {
	Name       string     `json:"name"`
	Properties Properties `json:"properties"`
}

type Properties struct {
	Access                               string   `json:"access"`
	Description                          string   `json:"description"`
	DestinationAddressPrefix             string   `json:"destinationAddressPrefix"`
	DestinationAddressPrefixes           []string `json:"destinationAddressPrefixes"`
	DestinationApplicationSecurityGroups []string `json:"destinationApplicationSecurityGroups"`
	DestinationPortRange                 int      `json:"destinationPortRange"`
	DestinationPortRanges                []int    `json:"destinationPortRanges"`
	Direction                            string   `json:"direction"`
	Priority                             int      `json:"priority"`
	Protocol                             string   `json:"protocol"`
	SourceAddressPrefix                  string   `json:"sourceAddressPrefix"`
	SourceAddressPrefixes                []string `json:"sourceAddressPrefixes"`
	SourceApplicationSecurityGroups      []string `json:"sourceApplicationSecurityGroups"`
	SourcePortRange                      int      `json:"sourcePortRange"`
	SourcePortRanges                     []int    `json:"sourcePortRanges"`
}

// getCmd represents the get command
var getCmd = &cobra.Command{
	Use:   "get",
	Short: "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Run: func(cmd *cobra.Command, args []string) {
		// fmt.Println("get called")
		// var fileName string
		// var error error

		argument := args[0]

		jsonFile, err := os.Open(argument)

		if err != nil {
			fmt.Println(err)
		}
		fmt.Printf("Opened %s successfully\n\n", "sampleResponse.json")

		defer jsonFile.Close()

		byteValue, _ := ioutil.ReadAll(jsonFile)

		var securityRules SecurityRules

		json.Unmarshal(byteValue, &securityRules)

		for i := 0; i < len(securityRules.SecurityRules); i++ {
			fmt.Printf("\033[1;34mSecurity rule names: %s\033[0m\n", securityRules.SecurityRules[i].Name)
		}
	},
}

func init() {
	rootCmd.AddCommand(getCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// getCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// getCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
