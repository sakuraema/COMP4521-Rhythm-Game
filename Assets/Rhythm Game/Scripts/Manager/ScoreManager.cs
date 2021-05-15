using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core.Utilities;

public class ScoreManager : Singleton<ScoreManager>
{
	private int m_PerfectCount;
	private int m_GoodCount;
	private int m_MissedCount;

	public int PerfectCount { get => m_PerfectCount; set => m_PerfectCount = value; }
	public int GoodCount { get => m_GoodCount; set => m_GoodCount = value; }
	public int MissedCount { get => m_MissedCount; set => m_MissedCount = value; }
}
