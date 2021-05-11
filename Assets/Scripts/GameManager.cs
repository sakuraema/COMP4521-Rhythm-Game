using Core.Utilities;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : Singleton<GameManager>
{
	public int perfectCount;
	public int goodCount;
	public int missedCount;

	protected override void Awake()
	{
		base.Awake();
		Application.targetFrameRate = 300;
	}
}
