using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LongNote : Note
{
	private bool m_Triggered = false;
	private bool m_Pressing = true;
	private float m_PressedPosition;
	private float m_ReleasedPosition;

	public bool Triggered
	{
		get => m_Triggered;
		set
		{
			if (value)
			{
				float percentage = 1 - ((transform.position.z + m_Length / 2f) / m_Length);
				m_Triggered = value;
				m_PressedPosition = Mathf.Max(0f, percentage);
				//Debug.Log("Pressed on " + m_PressedPosition * 100f + "%");
			}
		}
	}

	public bool Pressing
	{
		get => m_Pressing;
		set
		{
			if (m_Triggered && m_Pressing)
			{
				float percentage = 1 - ((transform.position.z + m_Length / 2f) / m_Length);
				m_Pressing = value;
				m_ReleasedPosition = Mathf.Min(1f, percentage);

				var hitRange = m_ReleasedPosition - m_PressedPosition;
				if (hitRange > 0.8f)
				{
					m_Score = ScoringValue.Perfect;
				}
				else if (hitRange > 0.2f)
				{
					m_Score = ScoringValue.Good;
				}
				//Debug.Log("Released on " + m_ReleasedPosition * 100f + "%");
			}
		}
	}
}
