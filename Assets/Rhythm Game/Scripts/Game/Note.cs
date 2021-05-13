using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class Note : MonoBehaviour
{
	public enum ScoringValue
	{
		Perfect,
		Good,
		Missed
	}

	protected float m_Length;
	protected ScoringValue m_Score = ScoringValue.Missed;

	public ScoringValue Score
	{
		get => m_Score;
	}

	protected virtual void Awake()
	{
		m_Length = transform.lossyScale.z;
	}
}
