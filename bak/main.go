package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
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

// "provisioningState": "Succeeded",
// "protocol": "*",
// "sourcePortRange": "*",
// "destinationPortRange": "80",
// "sourceAddressPrefix": "*",
// "destinationAddressPrefix": "*",
// "access": "Allow",
// "priority": 130,
// "direction": "Inbound"

func main() {
	jsonFile, err := os.Open("../samples/anotherSampleResponse.json")

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

}
