using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Detector : MonoBehaviour
{
	private List<Bar> m_BarInside = new List<Bar>();
	private List<LongPress> m_LongPressInside = new List<LongPress>();

	public List<Bar> BarInside { get => m_BarInside; set => m_BarInside = value; }
	public List<LongPress> LongPressInside { get => m_LongPressInside; set => m_LongPressInside = value; }

	public void Remove(Bar bar)
	{
		if (bar is LongPress)
		{
			m_LongPressInside.Remove(bar as LongPress);
			bar.gameObject.SetActive(false);
		}
		else
		{
			m_BarInside.Remove(bar);
			bar.gameObject.SetActive(false);
		}
	}

	private void OnTriggerEnter(Collider other)
	{
		var bar = other.GetComponent<Bar>();
		if (bar == null) return;

		if (bar is LongPress)
		{
			m_LongPressInside.Add(bar as LongPress);
		}
		else
		{
			m_BarInside.Add(bar);
		}
	}

	private void OnTriggerExit(Collider other)
	{
		var bar = other.GetComponent<Bar>();
		if (bar == null) return;
		//Debug.Log("Missed");
		if (bar is LongPress)
		{
			var longPress = bar as LongPress;
			if (longPress.triggered && longPress.pressing)
			{
				longPress.releasedPosition = 1f;
				Debug.Log("Hold until " + longPress.releasedPosition * 100 + "%");
			}
		}
		GameManager.instance.missedCount++;
		Remove(bar);
	}
}
