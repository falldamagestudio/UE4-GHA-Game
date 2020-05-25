// Copyright Epic Games, Inc. All Rights Reserved.

#include "ExampleGameGameMode.h"
#include "ExampleGameCharacter.h"
#include "UObject/ConstructorHelpers.h"

AExampleGameGameMode::AExampleGameGameMode()
{
	// set default pawn class to our Blueprinted character
	static ConstructorHelpers::FClassFinder<APawn> PlayerPawnBPClass(TEXT("/Game/ThirdPersonCPP/Blueprints/ThirdPersonCharacter"));
	if (PlayerPawnBPClass.Class != NULL)
	{
		DefaultPawnClass = PlayerPawnBPClass.Class;
	}
}
