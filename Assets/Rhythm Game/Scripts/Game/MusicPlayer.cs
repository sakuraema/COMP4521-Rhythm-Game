using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core.Utilities;
using UnityEngine.Events;

public class MusicPlayer : Singleton<MusicPlayer>
{
	public float startDelay;
	public float endDelay;
	public UnityEvent onMusicEnd;

    private Timer m_DelayTimer;
	private AudioSource m_AudioSource;

	protected override void Awake()
    {
		base.Awake();

		m_AudioSource = GetComponent<AudioSource>();
        m_DelayTimer = new Timer(startDelay, () =>
		{
			m_AudioSource.Play();
			m_DelayTimer = new Timer(m_AudioSource.clip.length + endDelay, () => onMusicEnd.Invoke());
		});
    }

    protected void FixedUpdate()
    {
        m_DelayTimer?.Tick(Time.fixedDeltaTime);
        //m_Time += Time.fixedDeltaTime;
        //if (m_Time > 30.0f)
            //StartCoroutine(AudioFade.StartFade(musicSource, 2.0f, 0.0f));
    }
}
