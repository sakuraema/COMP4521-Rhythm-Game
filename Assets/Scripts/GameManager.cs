using Core.Utilities;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : Singleton<GameManager>
{
	public int perfectCount;
	public int goodCount;
	public int missedCount;

    static public float s_SpeedOffset = 1.0f;
}
