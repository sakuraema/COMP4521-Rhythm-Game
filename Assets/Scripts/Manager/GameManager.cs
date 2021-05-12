using Core.Utilities;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core.Data;

public class GameManager : GameManagerBase<GameManager, GameDataStore>
{
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
