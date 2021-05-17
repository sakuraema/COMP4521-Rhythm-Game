using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Detector : MonoBehaviour
{
	private List<Note> m_Notes = new List<Note>();

	public List<Note> Notes { get => m_Notes; set => m_Notes = value; }

	public void Remove(Note note)
	{
		m_Notes.Remove(note);

		if (note.Score == Note.ScoringValue.Perfect)
		{
			ScoreManager.instance.PerfectCount++;
			PopUpImage.instance.ShowPopUp(PopUpImage.PopUpType.Perfect, transform.position, Quaternion.identity);
			ComboCounter.instance.IncreaseCombo();
		}
		else if (note.Score == Note.ScoringValue.Good)
		{
			ScoreManager.instance.GoodCount++;
			PopUpImage.instance.ShowPopUp(PopUpImage.PopUpType.Great, transform.position, Quaternion.identity);
			ComboCounter.instance.IncreaseCombo();
		}
		else
		{
			ScoreManager.instance.MissedCount++;
			PopUpImage.instance.ShowPopUp(PopUpImage.PopUpType.Miss, transform.position, Quaternion.identity);
			ComboCounter.instance.ResetCombo();
		}
		note.gameObject.SetActive(false);
		Destroy(note.gameObject);
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
