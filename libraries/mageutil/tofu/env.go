package tofu

import (
	"fmt"
	"os"
)

type StageProps struct {
	Region      string
	Environment string
}

func getStageEnvVars() StageProps {
	return StageProps{
		Region:      getEnvValueOrWaitForInput("REGION", "eu-central-1"),
		Environment: getEnvValueOrWaitForInput("ENVIRONMENT", "test"),
	}
}

func getEnvValueOrWaitForInput(key string, defaultValue string) string {
	value, ok := os.LookupEnv(key)
	if !ok {
		fmt.Printf("%s [%s]: ", key, defaultValue)

		var input string
		_, err := fmt.Scanln(&input)
		if err != nil {
			return defaultValue
		}

		return input
	}
	return value
}
