using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Detector : MonoBehaviour
{
	static private readonly int SCORE_SCALING_FACTOR = 50;
	private List<Note> m_Notes = new List<Note>();

	public bool IsHoldingLongNote
	{
		get
		{
			if (m_Notes.Count <= 0) return false;
			else
			{
				var note = m_Notes[0] as LongNote;
				if (note == null) return false;
				if (note.Triggered && note.Pressing) return true;
				else return false;
			}
		}
	}
	public List<Note> Notes { get => m_Notes; set => m_Notes = value; }

	public void Remove(Note note, bool isDestroy = true)
	{
		if (m_Notes.Remove(note))
		{
			if (note.Score == Note.ScoringValue.Perfect)
			{
				LevelManager.instance.PerfectCount++;
				LevelManager.instance.Score += 300 + 300 * ComboCounter.instance.Combo / SCORE_SCALING_FACTOR;
				PopUpManager.instance.ShowPopUp(PopUpManager.PopUpType.Perfect, transform.position, Quaternion.identity);
				ComboCounter.instance.IncreaseCombo();
			}
			else if (note.Score == Note.ScoringValue.Good)
			{
				LevelManager.instance.GoodCount++;
				LevelManager.instance.Score += 150 + 150 * ComboCounter.instance.Combo / SCORE_SCALING_FACTOR;
				PopUpManager.instance.ShowPopUp(PopUpManager.PopUpType.Great, transform.position, Quaternion.identity);
				ComboCounter.instance.IncreaseCombo();
			}
			else
			{
				LevelManager.instance.MissedCount++;
				PopUpManager.instance.ShowPopUp(PopUpManager.PopUpType.Miss, transform.position, Quaternion.identity);
				ComboCounter.instance.ResetCombo();
			}
		}

		if (isDestroy)
		{
			Destroy(note.gameObject);
		}
		//Debug.Log("Remove note");
	}

	private void OnTriggerEnter(Collider other)
	{
		var note = other.GetComponent<Note>();
		if (note == null) return;

		m_Notes.Add(note);
	}

	private void OnTriggerExit(Collider other)
	{
		var note = other.GetComponent<Note>();
		if (note == null) return;

		if (note is LongNote)
		{
			var longPress = note as LongNote;
			longPress.Pressing = false;
		}

		Remove(note);
	}
}
