using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Track : MonoBehaviour
{
	static private readonly float EFFECTIVE_DISTANCE_FACTOR = 8f;

	public Material original;
	public Material selected;
	public Detector[] detectors;
	public KeyCode key;

	private float m_PerfectDistance;
	private float m_EffectiveDistance;

	protected void Awake()
	{
		m_EffectiveDistance = TestScroller.instance.Speed / EFFECTIVE_DISTANCE_FACTOR / 2f;
		m_PerfectDistance = m_EffectiveDistance / 2f;
		foreach (var item in detectors)
		{
			var originalSize = item.GetComponent<BoxCollider>().size;
			item.GetComponent<BoxCollider>().size = new Vector3(originalSize.x, originalSize.y, m_EffectiveDistance * 2f);
		}
	}

	protected void Update()
	{
		RaycastHit hitInfo;
		Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
		var layerMask = 1 << 8;
		bool isMouseOnTrack = false;
		if (Input.GetMouseButton(0) && Physics.Raycast(ray, out hitInfo, 100.0f, layerMask))
		{
			isMouseOnTrack = hitInfo.transform == transform;
		}

		if ((Input.GetMouseButtonDown(0) && isMouseOnTrack) || Input.GetKeyDown(key))
		{
			foreach (var detector in detectors)
			{
				if (detector.BarInside.Count > 0)
				{
					float distance = Mathf.Abs(detector.BarInside[0].transform.position.z);
					if (distance < m_PerfectDistance)
					{
						Debug.Log("Perfect");
					}
					else
					{
						Debug.Log("Good");
					}
					detector.Remove(detector.BarInside[0]);
				}

				if (detector.LongPressInside.Count > 0 && detector.LongPressInside[0].triggered == false)
				{
					var longPress = detector.LongPressInside[0];
					longPress.triggered = true;

					var percentage = 1 - ((longPress.transform.position.z + longPress.Length / 2f) / longPress.Length);
					longPress.pressedPosition = Mathf.Max(0f, percentage);
					Debug.Log("Triggered at " + longPress.pressedPosition * 100 + "% on " + longPress.transform.position);
				}
			}
		}

		foreach (var detector in detectors)
		{
			if (detector.LongPressInside.Count > 0)
			{
				var longPress = detector.LongPressInside[0];
				if (detector.LongPressInside[0].triggered && detector.LongPressInside[0].pressing == true)
				{
					if ((Input.GetMouseButton(0) && isMouseOnTrack) || Input.GetKey(key))
					{
						//Debug.Log("Pressing");
					}
					else
					{
						detector.LongPressInside[0].pressing = false;
						var percentage = 1 - ((longPress.transform.position.z + longPress.Length / 2f) / longPress.Length);
						longPress.releasedPosition = Mathf.Min(1f, percentage);
						Debug.Log("Unpressed on " + longPress.releasedPosition * 100 + "% on " + longPress.transform.position);
					}
				}
			}
		}

		if (Input.GetMouseButton(0) && isMouseOnTrack)
		{
			GetComponent<Renderer>().material = selected;
			return;
		}

		// Debug
		if (Input.GetKey(key))
		{
			GetComponent<Renderer>().material = selected;
			return;
		}
		GetComponent<Renderer>().material = original;
	}
}
