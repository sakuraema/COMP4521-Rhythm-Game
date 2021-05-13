using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Detector : MonoBehaviour
{
	private List<Note> m_Notes = new List<Note>();

	public List<Note> Notes { get => m_Notes; set => m_Notes = value; }

	public void Remove(Note note)
	{
		if (m_Notes.Remove(note))
		{
			if (note.Score == Note.ScoringValue.Perfect)
			{
				ScoreManager.instance.perfectCount++;
			}
			else if (note.Score == Note.ScoringValue.Good)
			{
				ScoreManager.instance.goodCount++;
			}
			else
			{
				ScoreManager.instance.missedCount++;
			}
			note.gameObject.SetActive(false);
			Destroy(note.gameObject);
		}
		else
		{
			Debug.LogError("Try to remove note that has already been removed");
		}
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
