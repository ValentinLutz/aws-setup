package tofu

import (
	"root/libraries/mageutil"
)

type StageProps struct {
	Region      string
	Environment string
}

func getStageEnvVars() StageProps {
	return StageProps{
		Region:      mageutil.GetEnvValueOrWaitForInput("REGION", "eu-central-1"),
		Environment: mageutil.GetEnvValueOrWaitForInput("ENVIRONMENT", "test"),
	}
}
