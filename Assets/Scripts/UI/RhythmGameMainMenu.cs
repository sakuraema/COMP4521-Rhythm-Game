using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core.UI;

public class RhythmGameMainMenu : MainMenu
{
	public SimpleMainMenuPage optionsMenu;
	public SimpleMainMenuPage mainMenu;

	public void ShowMainMenu()
	{
		ChangePage(mainMenu);
	}

	public void ShowOptionsMenu()
	{
		ChangePage(optionsMenu);
	}

	protected virtual void Awake()
	{
		ShowMainMenu();
	}
}
