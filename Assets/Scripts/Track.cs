using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Track : MonoBehaviour
{
	public Material original;
	public Material selected;
	public BarDetector[] detectors;
	public KeyCode key;
	public AudioClip clip;

	private float m_PerfectDistance;
	private float m_EffectiveDistance;
	private AudioSource m_AudioSource;

	protected void Awake()
	{
		m_AudioSource = GetComponent<AudioSource>();
		m_EffectiveDistance = TestScroller.instance.Speed / 2f / 2f;
		m_PerfectDistance = m_EffectiveDistance / 2f;
		foreach (var item in detectors)
		{
			item.GetComponent<BoxCollider>().size = new Vector3(2f, 1f, m_EffectiveDistance * 2f);
		}
	}

	protected void Update()
	{
		if (Input.GetMouseButtonDown(0) || Input.GetKeyDown(key))
		{
			foreach (var detector in detectors)
			{
				if (detector.BarInside.Count > 0)
				{
					float distance = Mathf.Abs(detector.BarInside[0].transform.position.z);
					if (distance < m_PerfectDistance)
					{
						Debug.Log("Perfect");
						m_AudioSource.PlayOneShot(clip);
					}
					else
					{
						Debug.Log("Good");
						m_AudioSource.PlayOneShot(clip);
					}
					detector.Remove(detector.BarInside[0]);
				}
			}
		}

		if (Input.GetMouseButton(0))
		{
			RaycastHit hitInfo;
			Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
			var layerMask = 1 << 8;
			if (Physics.Raycast(ray, out hitInfo, 100.0f, layerMask))
			{
				if (hitInfo.transform == this.transform)
				{
					GetComponent<Renderer>().material = selected;
					return;
				}
			}
		}

		// Debug
		if (Input.GetKey(key))
		{
			GetComponent<Renderer>().material = selected;
			return;
		}
		GetComponent<Renderer>().material = original;
	}

	protected void FixedUpdate()
	{

	}
}
