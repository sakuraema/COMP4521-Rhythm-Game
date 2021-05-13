using Core.Utilities;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core.Data;
using Core.Game;

public class GameManager : GameManagerBase<GameManager, GameDataStore>
{
	public LevelList levelList;

	public float ScrollSpeed
	{
		get => m_DataStore.scrollSpeed;
		set
		{
			m_DataStore.scrollSpeed = value;
			SaveData();
		}
	}

	protected override void Awake()
	{
		base.Awake();
		Application.targetFrameRate = 300;
	}
}
