using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core.Data;

public class GameDataStore : GameDataStoreBase
{
	public float scrollSpeed = 10f;
	public string displayName = "Player";

	/// <summary>
	/// Outputs to debug
	/// </summary>
	public override void PreSave()
	{
		Debug.Log("[GAME] Saving Game");
	}

	/// <summary>
	/// Outputs to debug
	/// </summary>
	public override void PostLoad()
	{
		Debug.Log("[GAME] Loaded Game");
	}
}
