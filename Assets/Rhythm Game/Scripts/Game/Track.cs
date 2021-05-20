using Core.Utilities;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Track : MonoBehaviour
{
	static private readonly float EFFECTIVE_DISTANCE_FACTOR = 4f;

	public Material original;
	public Material selected;
	public Detector detector;
	public KeyCode key;
	public LayerMask trackLayer;
	public ParticleSystem longEffect;
	public ParticleSystem shortEffect;
	public bool dynamicDetectorSize = true;

	private float m_PerfectDistance;
	private float m_GoodDistance;
	private float m_EffectiveDistance;
	private RepeatingTimer m_ComboTimer;
	private LongNote m_CurrentHoldingLongNote;

	bool IsMouseOnTrack
	{
		get
		{
			RaycastHit hitInfo;
			Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);

			return Physics.Raycast(ray, out hitInfo, 100.0f, trackLayer) && hitInfo.transform == transform;
		}
	}

	bool IsTouchOnTrack(Touch touch)
	{
		RaycastHit hitInfo;
		Ray ray = Camera.main.ScreenPointToRay(touch.position);

		return Physics.Raycast(ray, out hitInfo, 100.0f, trackLayer) && hitInfo.transform == transform;
	}

	void HitNote()
	{
		if (detector.Notes.Count <= 0) return;

		var note = detector.Notes[0];
		if (note is SingleNote)
		{
			var singleNote = note as SingleNote;
			float distance = Mathf.Abs(note.transform.position.z);

			if (distance < m_GoodDistance)
			{
				singleNote.Hit(distance < m_PerfectDistance);
				shortEffect.Play();
			}

			detector.Remove(note);
		}
		else
		{
			var longNote = note as LongNote;
			if (!longNote.Triggered)
			{
				longNote.Triggered = true;
			}
		}
	}

	void HoldNote()
	{
		if (detector.IsHoldingLongNote)
		{
			if (m_ComboTimer == null)
				m_ComboTimer = new RepeatingTimer(0.1f, () => {
					LevelManager.instance.Score += 50;
					ComboCounter.instance.IncreaseCombo();
				});
			if (!longEffect.isPlaying) longEffect.Play();
		}
		else
		{
			m_ComboTimer = null;
			if (!longEffect.isStopped) longEffect.Stop(true, ParticleSystemStopBehavior.StopEmittingAndClear);
		}
	}

	void ReleaseNote()
	{
		if (detector.Notes.Count <= 0) return;

		// Only LongNote can be released
		var longNote = detector.Notes[0] as LongNote;

		if (longNote && longNote.Triggered)
		{
			m_ComboTimer = null; // Force reset timer when release long note
			longNote.Pressing = false;
			detector.Remove(longNote, false);
		}
	}

	protected void Awake()
	{
		m_GoodDistance = Scroller.instance.Speed / EFFECTIVE_DISTANCE_FACTOR / 2f;
		m_PerfectDistance = m_GoodDistance / 2f;
		m_EffectiveDistance = m_GoodDistance / 2f * 3f;

		if (dynamicDetectorSize)
		{
			var detectorHitBox = detector.GetComponent<BoxCollider>();
			detectorHitBox.size = new Vector3(detectorHitBox.size.x, detectorHitBox.size.y, m_EffectiveDistance * 2f);
		}
	}

	protected void Update()
	{
		if (PauseMenu.isOn) return;
		m_ComboTimer?.Tick(Time.deltaTime);
		// Keyboard and mouse input
#if UNITY_EDITOR
		if ((Input.GetMouseButtonDown(0) && IsMouseOnTrack) || Input.GetKeyDown(key))
		{
			HitNote();
		}

		if ((Input.GetMouseButton(0) && IsMouseOnTrack) || Input.GetKey(key))
		{
			GetComponent<Renderer>().material = selected;
			HoldNote();
		}
		else
		{
			GetComponent<Renderer>().material = original;
			ReleaseNote();
			if (!longEffect.isStopped) longEffect.Stop(true, ParticleSystemStopBehavior.StopEmittingAndClear);
		}
#elif UNITY_IOS || UNITY_ANDROID
		// Touch input
		bool isAnyTouchOnTrack = false;
		for (int i = 0; i < Input.touchCount; ++i)
		{
			if (!IsTouchOnTrack(Input.GetTouch(i))) continue;
			isAnyTouchOnTrack = true;
			// Pressed on this frame
			if (Input.GetTouch(i).phase == TouchPhase.Began)
			{
				HitNote();
				break;
			}
		}

		if (isAnyTouchOnTrack)
		{
			GetComponent<Renderer>().material = selected;
			HoldNote();
		}
		else
		{
			GetComponent<Renderer>().material = original;
			ReleaseNote();
			if (!longEffect.isStopped) longEffect.Stop(true, ParticleSystemStopBehavior.StopEmittingAndClear);
		}
#endif
	}
}
