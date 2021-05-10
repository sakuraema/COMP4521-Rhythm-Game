using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BarDetector : MonoBehaviour
{
	private List<Bar> m_BarInside = new List<Bar>();

	public List<Bar> BarInside { get => m_BarInside; set => m_BarInside = value; }

	public void Remove(Bar bar)
	{
		m_BarInside.Remove(bar);
		Destroy(bar.gameObject);
		//Scroller.instance.ReturnBarToPool(bar);
	}

	private void OnTriggerEnter(Collider other)
	{
		var bar = other.GetComponent<Bar>();
		if (bar == null) return;

		m_BarInside.Add(bar);
	}

	private void OnTriggerExit(Collider other)
	{
		var bar = other.GetComponent<Bar>();
		if (bar == null) return;

		Remove(bar);

		Debug.Log("Missed");
	}
}
