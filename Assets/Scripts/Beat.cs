

public class Beat
{
	[System.Serializable]
	public enum BeatType
	{
		Bar,
		Slide,
	}

	BeatType type;
	int index = 0;
}
