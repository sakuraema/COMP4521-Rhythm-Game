using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SingleNote : Note
{
	public void Hit(bool isPerfect)
	{
		m_Score = isPerfect ? ScoringValue.Perfect : ScoringValue.Good;
	}
}
