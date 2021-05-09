using Core.Utilities;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Beatmap : Singleton<Beatmap>
{
	public enum Snap
	{
		Full,
		Half,
		Quarter,
		OneThird
	}
	public List<Beat> beats = new List<Beat>();
	public float BGM;
	public Snap snap;
}
