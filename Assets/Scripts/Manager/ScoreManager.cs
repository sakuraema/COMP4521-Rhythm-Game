using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core.Utilities;

public class ScoreManager : Singleton<ScoreManager>
{
	[HideInInspector]
	public int perfectCount;
	[HideInInspector]
	public int goodCount;
	[HideInInspector]
	public int missedCount;
}
