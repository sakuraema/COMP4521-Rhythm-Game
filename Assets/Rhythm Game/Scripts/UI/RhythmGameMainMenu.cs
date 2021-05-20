using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core.UI;

public class RhythmGameMainMenu : MainMenu
{
	public SimpleMainMenuPage optionsMenu;
	public SimpleMainMenuPage mainMenu;
	public SimpleMainMenuPage levelSelectMenu;

	public void ShowMainMenu()
	{
		ChangePage(mainMenu);
	}

	public void ShowLevelSelectMenu()
	{
		ChangePage(levelSelectMenu);
	}

	public void ShowOptionsMenu()
	{
		ChangePage(optionsMenu);
	}

	protected virtual void Awake()
	{
		ShowMainMenu();
	}

	protected virtual void Update()
	{
		if (Input.GetKeyDown(KeyCode.Escape))
		{
			if ((SimpleMainMenuPage)m_CurrentPage == mainMenu)
			{
				Application.Quit();
			}
			else
			{
				Back();
			}
		}
	}
}
