using UnityEngine;

[System.Serializable]
public class Beat
{
	[System.Serializable]
	public enum BeatType
	{
		Bar,
		Slide,
	}

	public BeatType type;
	public float delay;
	public bool[] tracks;
}
